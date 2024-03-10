from flask import Flask, render_template, jsonify
import requests

app = Flask(__name__)

# Environment Variables
prometheus_url = "http://prometheus:9090/api/v1/"

mem_usage = "query?query=node_memory_MemTotal_bytes - node_memory_MemFree_bytes"
cpu_usage = "query?query=100 - (avg(irate(node_cpu_seconds_total{mode='idle'}[5m])) by (instance) * 100)"
disk_status = "query?query=node_filesystem_size_bytes{fstype!~'tmpfs|squashfs'} - node_filesystem_free_bytes{fstype!~'tmpfs|squashfs'}"

@app.route('/', methods=['GET'])
def prometheus_service():
    # Logic for CPU Data
    cpu_response = requests.get(prometheus_url + cpu_usage)
    cpu_data = cpu_response.json()
    if cpu_data["status"] == "success":
        cpu_value = float(cpu_data["data"]["result"][0]["value"][1])
    else:
        cpu_value = "ERROR: Failed to retrieve system data from Prometheus"
    # Logic for Memory Data
    mem_response = requests.get(prometheus_url + mem_usage)
    mem_data = mem_response.json()
    if mem_data["status"] == "success":
        mem_value = int(mem_data["data"]["result"][0]["value"][1])
    else:
        mem_value = "ERROR: Failed to retrieve system data from Prometheus"

    # Logic for Diskspace Data
    disk_response = requests.get(prometheus_url + disk_status)
    disk_data = disk_response.json()
    if disk_data["status"] == "success":
        disk_value = int(disk_data["data"]["result"][0]["value"][1])
    else:
        disk_value = "ERROR: Failed to retrieve system data from Prometheus"

    # Creating JSON response
    response_data = {
        'memory_usage': f'{int(mem_value) / 1000000000} GB',
        'disk_status': f'{int(disk_value) / 1000000000} GB free',
        'cpu_usage': f'{cpu_value} % CPU in use'

        }

    return jsonify(response_data)
    
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
