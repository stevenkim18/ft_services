echo "docker-env"
eval $(minikube docker-env)

echo "metalLB apply"
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/metallb.yaml
kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"
kubectl create -f ./srcs/metallb/config.yaml

IP=$(kubectl get node -o=custom-columns='DATA:status.addresses[0].address' | sed -n 2p)
printf "Minikube IP: ${IP}"

echo "nginx image build..."
docker build -t ft_nginx ./srcs/nginx
echo "ftps image build..."
docker build -t ft_ftps ./srcs/ftps --build-arg IP=${IP}
echo "mysql image build..."
docker build -t ft_mysql ./srcs/mysql
echo "phpmyadmin image build..."
docker build -t ft_phpmyadmin ./srcs/phpmyadmin
echo "wordpress image build..."
docker build -t ft_wordpress ./srcs/wordpress --build-arg IP=${IP}

echo "nginx service create..."
kubectl create -f ./srcs//yaml/nginx.yaml
echo "ftps service create..."
kubectl create -f ./srcs/yaml/ftps.yaml
echo "mysql service create..."
kubectl create -f ./srcs/yaml/mysql.yaml
echo "phpmyadmin service create..."
kubectl create -f ./srcs/yaml/phpmyadmin.yaml
echo "wordpress service create..."
kubectl create -f ./srcs/yaml/wordpress.yaml