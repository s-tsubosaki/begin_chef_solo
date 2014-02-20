#
# Cookbook Name:: ec2_micro_swap
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# VPC内のインスタンスだと、node[:ec2]がnilになる。
# そのため、/etc/chef/ohai/hints/ec2.jsonに{}を書き込んでおく
is_ec2_micro = !node[:ec2].nil? && node[:ec2][:instance_type] == 't1.micro'
bash 'create ec2 t1.micro swapfile' do
  code <<-EOC
    dd if=/dev/zefo of=/swap.img bs=1M count=2048
    chmod 600 /swap.img
    mkswap /swap.img
    echo 
  EOC

  only_if { is_ec2_micro }
  creates "/swap.img"
end

mount '/dev/null' do # swap file entry for fstab
  action :enable # cannot mount; only add to fstab
  device '/swap.img'
  fstype 'swap'
  only_if { is_ec2_micro }
end

bash 'activate swap' do
  code 'swapon -ae'
  only_if "test `cat /proc/swaps | wc -l` -eq 1"
end
