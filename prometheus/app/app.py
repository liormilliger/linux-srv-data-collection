from flask import Flask, jsonify
import requests

app = Flask(__name__)

# Environment Variables
prometheus_api = "http://prometheus:9090/api/v1/"
prom_query_call = "query?query="

metrics = {
    "mem_usage": "(node_memory_Active_bytes/node_memory_MemTotal_bytes*100)",
    "cpu_usage": "(sum by (cpu)(rate(node_cpu_seconds_total{mode!='idle'}[5m]))*100)",
    "disk_status": "(1 -(node_filesystem_free_bytes  {mountpoint='/etc/hostname'}/ node_filesystem_size_bytes {mountpoint='/etc/hostname'})) * 100 "
}

@app.route('/', methods=['GET'])
def prometheus_service():

    metrics_data = {}

    for metric_name, metric_url in metrics.items():
        response = requests.get(prometheus_api + prom_query_call + metric_url)
        data = response.json()

        if data["status"] == "success":
            values = [result["value"][1] for result in data["data"]["result"]]
            # value = data["data"]["result"][:]["value"][1]

            prefix = metric_name.split('_')[0]
            res = ', '.join([f'{prefix}-{index}: {float(value):.2f}%' for index, value in enumerate(values)])
            metrics_data[metric_name] = res
        else:
            metrics_data[metric_name] = "ERROR: Failed to retrieve system data from Prometheus"

    response_data = {
        'memory_usage': metrics_data["mem_usage"],
        'free_disk_space': metrics_data["disk_status"],
        'cpu_usage': metrics_data["cpu_usage"]
    }

    return jsonify(response_data)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)