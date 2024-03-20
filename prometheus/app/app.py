from flask import Flask, jsonify
import requests

app = Flask(__name__)

# Environment Variables
prometheus_api = "http://prometheus:9090/api/v1/"


metrics = {
    "mem_usage": "query?query=(1 - (node_memory_MemFree_bytes + node_memory_Buffers_bytes + node_memory_Cached_bytes + node_memory_SReclaimable_bytes) / node_memory_MemTotal_bytes)*100",
    "cpu_usage": "query?query=(sum by (cpu)(rate(node_cpu_seconds_total{mode!='idle'}[5m]))*100)",
    "disk_status": "query?query=  (1 -(node_filesystem_free_bytes  {mountpoint='/etc/hostname'}/ node_filesystem_size_bytes {mountpoint='/etc/hostname'})) * 100 "
}

@app.route('/', methods=['GET'])
def prometheus_service():
    
    metrics_data = {}
    
    for metric_name, metric_url in metrics.items():
        response = requests.get(prometheus_api + metric_url)
        data = response.json()
        if data["status"] == "success":
            value = data["data"]["result"][0]["value"][1]
            metrics_data[metric_name] = value
        else:
            metrics_data[metric_name] = "ERROR: Failed to retrieve system data from Prometheus"
    
    response_data = {
        'memory_usage': f'{float(metrics_data["mem_usage"]):.2f}%',
        'free_disk_space': f'{float(metrics_data["disk_status"]):.2f}%',
        'cpu_usage': f'{float(metrics_data["cpu_usage"]):.2f}% of CPU is in use'
    }

    return jsonify(response_data)
  
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
