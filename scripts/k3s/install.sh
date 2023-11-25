#!/bin/bash

curl -sfL https://raw.githubusercontent.com/Cretezy/Swap/master/swap.sh | sh swap 4G

curl -sfL https://rancher-mirror.oss-cn-beijing.aliyuncs.com/k3s/k3s-install.sh | INSTALL_K3S_MIRROR=cn INSTALL_K3S_VERSION=v1.22.17+k3s1 INSTALL_K3S_EXEC="--tls-san 49.233.43.220" sh -