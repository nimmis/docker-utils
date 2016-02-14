# Extra files for nimmis docker containers

This is the commands used inside nimmis based containers
for extra functionality

## set_tz

In the default configuration Alpine is set to GMT time, if you need it
to use the corret time you can change to timezone for the container 
with this command, syntax is

	set_tz <timezone>

To get list of available timezones do

	set_tz list


### set timezone on startup

Add the environment variable TIMEZONE to the desired timezone, i.e to set timezone to 
CET Stockhome

	docker run -d -e TIMEZONE=Europa/Stockholm nimmis/alpine-micro

### set timezone in running container

Execute the command on the container as

	docker exec -ti <docker ID> set_tz Europa/Stockholm

### get list of timezones before starting container

Execute the following command, it will list available timezones and then
remove the container

	docker run --rm nimmis/alpine-micro set_tz list
