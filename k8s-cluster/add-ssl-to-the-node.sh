
openssl s_client -showcerts -connect docker-r.nexus.smart.com:443< /dev/null | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > ca.crt

cp ca.crt /etc/ssl/certs

update-ca-certificates