{ config, pkgs, ... }: {
  services.prometheus = {
    enable = true;
    scrapeConfigs = [
      {
        job_name = "prometheus";
        scrape_interval = "60s";
        static_configs = [
          {
            targets = ["localhost:9090"];
          }
        ];
      }
      {
        job_name = "node_exporter";
        scrape_interval = "30s";
        static_configs = [
          {
            targets = [
              "jessica.bun-galaxy.ts.net:9100"
              "amy.bun-galaxy.ts.net:9100"
              "fern.bun-galaxy.ts.net:9100"
              "loona.bun-galaxy.ts.net:9100"
            ];
          }
        ];
      }
      {
        job_name = "systemd_exporter";
        scrape_interval = "60s";
        static_configs = [
          {
            targets = [
              "jessica.bun-galaxy.ts.net:9558"
              "amy.bun-galaxy.ts.net:9558"
              "fern.bun-galaxy.ts.net:9558"
              "loona.bun-galaxy.ts.net:9558"
            ];
          }
        ];
      }

      {
        job_name = "kubernetes-pods";
        kubernetes_sd_configs = [
          {
            role = "pod";
            kubeconfig_file = "/etc/rancher/k3s/k3s.yaml";
          }
        ];
        relabel_configs = [
          {
            source_labels = ["__meta_kubernetes_pod_annotation_ashhhleyyy_dev_prometheus"];
            action = "keep";
            regex = "true";
          }
          {
            source_labels = ["__meta_kubernetes_pod_annotation_ashhhleyyy_dev_prometheus_metric_path"];
            action = "replace";
            target_label = "__metrics_path__";
            regex = "(.*)";
          }
          {
            source_labels = ["__address__" "__meta_kubernetes_pod_annotation_ashhhleyyy_dev_prometheus_port"];
            action = "replace";
            regex = "([^:]+)(?::\\d+)?;(\\d+)";
            replacement = "$1:$2";
            target_label = "__address__";
          }
          {
            action = "labelmap";
            regex = "__meta_kubernetes_pod_label_(.+)";
          }
          {
            source_labels = ["__meta_kubernetes_namespace"];
            action = "replace";
            target_label = "namespace";
          }
          {
            source_labels = ["__meta_kubernetes_pod_name"];
            action = "replace";
            target_label = "pod";
          }
        ]
      }
    ];
  };
}
