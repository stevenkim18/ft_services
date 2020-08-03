echo "docker-env"
eval $(minikube docker-env)

echo "nginx image build..."
docker build -t ft_nginx ./srcs/nginx

echo "metalLB manifest"
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/metallb.yaml
kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"
kubectl create -f ./srcs/metallb/config.yaml

echo "nginx service create..."
kubectl apply -f ./srcs/nginx.yaml