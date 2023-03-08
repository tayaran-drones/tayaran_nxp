# tayaran_nxp

## 1 Get laest version of PX$

`cd src/PX4-AutoPilot && git checkout main`

## 2 Run Vagrant Up
`vagrant up`

## 3 SSH Into Virtual Machine or Log in through GUI
`vagrant ssh` | log in to with `vagrant` as both username and password


## Gazebo Simulations
[https://docs.px4.io/v1.12/en/simulation/gazebo_vehicles.html](https://docs.px4.io/v1.12/en/simulation/gazebo_vehicles.html)

Go inside docker container using `docker attach px4` and run
`make px4_sitl gazebo_solo` for Quadrotor

## Testing
```
vagrant ssh
docker exec -it px4 make px4_sitl_default gazebo
```

## ROS2 Integration
Go inside docker container using `docker exec -it px4 bash`, navigate to parent directory using `cd ../..` and run
```
source /opt/ros/foxy/setup.bash
colcon build
```

