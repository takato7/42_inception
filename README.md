


Bonus
Redis
	changes on the configuration file from default
		- commented out "bind 127.0.0.1 -::1"
		- protected-mode yes --> no
		- maxmemory 10mb
		- maxmemory-policy allkeys-lfu
	refference
		- configuration file of redis https://redis.io/docs/latest/operate/oss_and_stack/management/config/

