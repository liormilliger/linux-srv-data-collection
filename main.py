from flask import Flask, render_template, redirect

app = Flask(__name__)

@app.route('/', methods=['GET'])
def welcome():
    return render_template('index.html')

@app.route('/dashboard', methods=['GET'])
def grafana_dashboard():
    # Assuming Grafana is running on port 3000
    grafana_url = "http://grafana:3000"
    return redirect(grafana_url)


@app.route('/system_data', methods=['GET'])
def system_data():
    log_file_path = '/host_logs/monitoring.log'

    # Read the last three lines from the log file
    with open(log_file_path, 'r') as file:
        last_lines = file.readlines()[-3:]

    # Initialize variables to store extracted data
    mem_usage = None
    cpu_usage = None
    disk_status = None

    # Parse the last three lines to extract memory usage, CPU usage, and disk status
    for line in last_lines:
        if "Memory Usage:" in line:
            mem_usage = line.split(":")[-1].strip()
        elif "CPU Usage:" in line:
            cpu_usage = line.split(":")[-1].strip()
        elif "Disk Status:" in line:
            disk_status = line.split(":")[-1].strip()

    # Construct data dictionary
    data = {
        'memory_usage': mem_usage,
        'cpu_usage': cpu_usage,
        'disk_status': disk_status
    }

    return render_template('system_data.html', data=data)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80, debug=True)
