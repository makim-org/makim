chmod +x /usr/local/bin/makim

systemctl daemon-reload
# Enable the makim service to start on boot
systemctl enable makim.service
# Start the makim service
systemctl start makim.service
