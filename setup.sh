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

echo "nginx service create..."
kubectl apply -f ./srcs//yaml/nginx.yaml
echo "ftps service create..."
kubectl apply -f ./srcs/yaml/ftps.yaml