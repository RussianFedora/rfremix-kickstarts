# rfremix-cloud-base.ks
#
# Maintainer(s):
# - Arkady L. Shane <ashejn [AT] russianfedora [DOT] pro>

%include spin-kickstarts/fedora-cloud-base-vagrant.ks

%post --erroronfail
cat >> ~vagrant/.ssh/authorized_keys << EOKEYS
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDd26awXafGOx5J/+uXd5GLEo/VQXVT3HsBk3NIMHZhMd0W6alFMEFLlDXqCJiRhFm3CNShjo6qQuK4P2z4aZjvgmnm3MF8nOVd5zXuFnJhgAe5ZUMbnNaLzJwItxrRW8AZqK+u5y1sjqon/T1wl9MVITwEbp/uwFOyTBfxYv4WH2e+EQYlIkuQibzbQL4P0UDCRqpFRHm6BHQikMeyIrt2cnrKlo10c2m/0Pqx11s7qGS4P1VABd+8qs/Jq3XO9p/YW9eArfAM2Lbv+xCbTbtQ6bj2pZ3oONA5Xh1OCDcffewML5uZnvtm7i/HgkldTDRNsqoDEAhRHrqKssiTDPuQg3jJzkTIS8ScTvt/Uqti+t2FV5hu/wRvWKnaO2BNudkotW+7sWO43Hbx690wAAjAgR69qr/ZK01+IGiUCAlkaH3i2Cp1M/+h0U7lPpOIJbYwNyjWJ9HTq+BJvJCIc8h49BKcvk3QvXBgPjRQUw4dPmTv30pRpVI07MXHXVq6NrsVcxFkNRmZ3G6G9reMoFtwq5gi7+YjNEOpCn4c+PrCIERA0tNm0m5hP/Z9StOzHM36sM7AiNBZLUjTRbuUFQ18a3h7I9Eg4+8ubqCBSqN+2I+KVcbFSkHSJFlSmBa5sdkj8DcvI1+RGrepk6QWCHFFdH1jQpJHRSXcmO1C+FYtaQ== ashejn@yandex-team.ru
EOKEYS
chmod 600 ~vagrant/.ssh/authorized_keys
chown -R vagrant:vagrant ~vagrant/.ssh/
%end
