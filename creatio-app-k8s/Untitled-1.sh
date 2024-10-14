creatio-uat      deduplication-data-service          ClusterIP      10.233.45.230   <none>           80/TCP                   137m
creatio-uat      deduplication-web-api               NodePort       10.233.25.145   <none>           80:31082/TCP             137m
creatio-uat      exchangelistner-api                 LoadBalancer   10.233.23.241   192.168.102.26   8080:30214/TCP           108m
creatio-uat      globalsearch-search-service         NodePort       10.233.36.218   <none>           80:30332/TCP             18h
creatio-uat      globalsearch-web-api                LoadBalancer   10.233.6.41     192.168.102.24   80:30193/TCP             18h
creatio-uat      globalsearch-web-indexing-service   NodePort       10.233.38.200   <none>           80:32021/TCP             18h
default          kubernetes                          ClusterIP      10.233.0.1      <none>           443/TCP                  19d
dev              app-service                         LoadBalancer   10.233.50.236   192.168.102.21   80:32441/TCP             11d
elasticsearch    elasticsearch-service               LoadBalancer   10.233.13.46    192.168.102.22   9200:31906/TCP           3d20h
kube-system      coredns                             ClusterIP      10.233.0.3      <none>           53/UDP,53/TCP,9153/TCP   19d
kube-system      metrics-server                      ClusterIP      10.233.56.89    <none>           443/TCP                  12d
metallb-system   metallb-webhook-service             ClusterIP      10.233.1.39     <none>           443/TCP                  11d
mongo            mongo-mongodb                       LoadBalancer   10.233.54.19    192.168.102.25   27017:31182/TCP          140m
postgresql       postgres-service                    ClusterIP      10.233.5.251    <none>           5432/TCP                 4d18h
rabbitmq         rabbitmq-mgt-ui-service             LoadBalancer   10.233.3.54     192.168.102.23   15672:32518/TCP          3d13h
rabbitmq         rabbitmq-service                    ClusterIP      10.233.3.108    <none>           5672/TCP                 3d13h
redis            redis                               ClusterIP      10.233.53.98    <none>           6379/TCP                 3d20h
redis            redis-sentinel                      ClusterIP      10.233.1.193    <none>           26379/TCP                4d21h

10.233.5.251
  POSTGRES_DB: ps_db
  POSTGRES_USER: ps_user
  POSTGRES_PASSWORD: ps-password

ES:
192.168.102.22

10.233.53.98

10.233.3.108
rabbitmq
rabbitmq
globalSearchVh

192.168.108.165:8084/creatio-k8s-repo