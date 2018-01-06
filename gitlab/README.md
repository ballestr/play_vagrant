# GitLab server

- An unnecessarily parametric ansible role, with funny dependencies, bad /tmp use etc :  
  https://github.com/geerlingguy/ansible-role-gitlab
- An unnecessarily parametric puppet module :  
  https://forge.puppet.com/vshn/gitlab
- A simple Vagrant/Bash for Ubuntu :  
  https://github.com/tuminoid/gitlab-installer

So, I wrote a simple Vagrant/Ansible setup, with no parametrisations, taking ideas from all the above.

- GitLab 10.3.3 on Centos7.4 + VirtualBox 5.1.18 on a MacBook 
- 2CPU + 2GB RAM seems tight. Recommended is 4GB.

## Testing
Browse to https://localhost:8443/ , set a new password, then login as `root` with the new password.

## High Availability
- https://about.gitlab.com/high-availability/
Seems a good starting point to look at backup / recovery needs & strategies.

## 