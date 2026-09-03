#!/bin/bash

echo 'ipxe script' >> kernel.txt
echo 'kernel=params' > kernel.txt
echo 'boot me' > kernel.txt

sed -e /'kernel'/'$'/' break=init$' kernel.txt

