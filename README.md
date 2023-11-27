## Demos from k6 Office Hours #47 (March 25, 2022)

> [!NOTE]
> These instructions have been updated as of k6 version 0.47.0 (fall 2023).
> Updates to k6 and highlighted extensions may have changed the workflow shown in the video demonstration.
> The following instructions should supersede those from the video.

### Running the `xk6-dashboard` natively

> [!NOTE]
> The `xk6-dashboard` extension was transferred to the Grafana organization!

* Generate a k6 binary with the [grafana/xk6-dashboard](https://github.com/szkiba/xk6-dashboard) extension
    ```shell
    go install go.k6.io/xk6/cmd/xk6@latest
    xk6 build --with github.com/grafana/xk6-dashboard@latest
    ```
* Run a test using [run-dashboard.sh](./run-dashboard.sh)
    ```shell
    ./run-dashboard.sh scripts/ramping-arr-rate.js
    ```
* Access the dashboard at http://127.0.0.1:5665/


### Build multiple extensions into a single Docker image

* Generate a multi-extension Docker image of k6 using [Dockerfile](./Dockerfile).
    ```shell
    docker build -t k6-extended:latest .
    ```

### Running the `xk6-output-influxdb` extension within Docker

* Start our _Grafana_ service backed by _InfluxDB_
    ```shell
    docker compose -f influxdb/docker-compose.yml up
    ```
* Run a test using [run-influxdb.sh](./run-influxdb.sh)
    ```shell
    ./run-influxdb.sh scripts/ramping-arr-rate.js
    ```
* Access the Grafana dashboard at http://localhost:3000/
* Shutdown Docker when finished running scripts
    ```shell
    docker compose -f influxdb/docker-compose.yml down
    ```

### Running the `xk6-output-timescaledb` extension within Docker

* Start our _Grafana_ service backed by _InfluxDB_
    ```shell
    docker compose -f timescaledb/docker-compose.yml up
    ```
* Run a test using [run-timescaledb.sh](./run-timescaledb.sh)
    ```shell
    ./run-timescaledb.sh scripts/ramping-arr-rate.js
    ```
* Access the Grafana dashboard at http://localhost:3000/
* Shutdown Docker when finished running scripts
    ```shell
    docker compose -f timescaledb/docker-compose.yml down
    ```

### Running the `xk6-output-prometheus-remote` extension within Docker

> [!IMPORTANT]
> The `xk6-output-prometheus-remote` extension is now built into the native k6 binary as an experimental extension.
> This removes the need to specially compile the extension, but does change some of the usage.

* Start our _Grafana_ service backed by _Prometheus_
    ```shell
    docker compose -f prometheus/docker-compose.yml up
    ```
* Run a test using [run-prometheus.sh](./run-prometheus.sh)
    ```shell
    ./run-prometheus.sh scripts/ramping-arr-rate.js
    ```
* Access the Grafana dashboard at http://localhost:3000/
* Shutdown Docker when finished running scripts
    ```shell
    docker compose -f prometheus/docker-compose.yml down
    ```
