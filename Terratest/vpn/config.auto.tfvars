vpc_cidr_eu_de = "10.10.0.0/16"
vpc_cidr_eu_nl = "10.11.0.0/16"

vpn_dpd = true // Dead peer detection (true = hold (default) false = disabled)

vpn_ike_policy_dh_algorithm         = "group15"  // Diffie-Hellman key exchange algorithm
vpn_ike_policy_auth_algorithm       = "sha2-256" // Authentication hash algorithm
vpn_ike_policy_encryption_algorithm = "aes-256"  // Encryption algorithm
vpn_ike_policy_lifetime             = 86400      // Lifetime of the security association in seconds.


vpn_ipsec_policy_protocol             = "esp"      // The security protocol used for IPSec to transmit and encapsulate user data.
vpn_ipsec_policy_pfs                  = "group20"  // The perfect forward secrecy mode
vpn_ipsec_policy_auth_algorithm       = "sha2-256" // Authentication hash algorithm
vpn_ipsec_policy_encryption_algorithm = "aes-256"  // Encryption algorithm
vpn_ipsec_policy_lifetime             = 3600       // Lifetime of the security association in seconds.

