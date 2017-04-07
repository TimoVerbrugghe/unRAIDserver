## Google Authenticator Install for Arch
# Install required packages
	pacaur -Syu libpam-google-authenticator

# Enable Google Authenticator on SSH
	nano /etc/pam.d/sshd
		auth required pam_google_authenticator.so # Put this line first!

	nano /etc/ssh/sshd_config
		ChallengeResponseAuthentication yes

# Generate secret key file
	google-authenticator
		# Follow steps

# Restart sshd
	systemctl restart sshd