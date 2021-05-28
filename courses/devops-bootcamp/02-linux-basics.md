# Linux Basics

- video: <https://techworld-with-nana.teachable.com/courses/devops-bootcamp/lectures/32585025>

## Introduction to Operating Systems

### Tasks of an Operating System

- Resource Allocation and Management

    - Process management
        - What's a process? small unit that executes on the computer
        - each process has own isolated space

    - Memory Management:
        - allocating working memory
        - every application needs some data to work
        - RAM is limited on the computer
        - Memory Swapping
            - happens when you're out of RAM
            - OS swaps memory between applications
            - on app becomes inactive, new one gets resources
            - swapping slows down your computer

    - Storage Management
        - aka secondary memory
        - persisting data long-term
        - hard drive

- Manage File System
    - Stored in a structured way
    - Unix systems: tree file system

- Management of IO Devices

- Security
    - managing users and permissions
    - each user has its own space
    - each user has permissions

- Networking
    - eg.: ports and IP address


### Operating Systems Components

Kernel: the heart (or brain) of the operating system

The kernel is the software who talks with the hardware.


### Standards

POSIX - Portable Operating Systems



## Virtualization

with virtualization no separate hardware needed

- hypervisor:
    - example: virtualbox
    - allows you create a virtual machine
    - you can only give resources you actually have
    - hardware resources are shared

- Benefits:
    - learn and experiment
    - don't endanbger your main OS
    - test your app on different OS

  
Type 1 vs Type 2 Hypervisor

- Type 2:
    - Virtualbox is type 2.
    - Typically used in personal computers
    - Installed on top of an Operating System

- Type 1:
    - Installed direct on hardware
    - aka bare metal hypervisors
    - examples: VMWare ESXi, MicroSoft Hyper-v
    - for servers
    - used by big companies

- Benefits:
    - efficient usage of hardware resources
    - use all the resources of a performant big server
    - users can choose any resource combinations

- Why are companies adopting Virtualization?
    - abstraction of the operating system from the hardware
    - OS is "portable" file that you can move around: Virtual Machine Image





