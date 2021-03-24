# gitlab CI/CD
[✏️](https://github.com/meleu/my-notes/edit/master/gitlab.md)

## test this

<https://docs.gitlab.com/ee/user/project/pages/getting_started/pages_from_scratch.html>


## GitLab tricks

### Add SSH key to a GitLab account

- Generate an SSH key pair:
```
ssh-keygen -t ed25519 -C "username@email.com"
```

- Copy the generated public key in `~/.ssh/id_ed25519.pub`

- Go to <https://gitlab.com> or local GitLab instance and sign in.

- Avatar in the upper right corner > Settings > SSH Keys

- Paste the public key into the Key text box

- Put a descriptive Title (e.g.: Work Laptop), and an (optional) expiration date.

- Click Add key


## Allowing communication with an insecure registry

[It's actually a `dockerd` trick, but still useful to stay here.]

When using a docker registry with no hash:

```yml
services:
#  - name: docker:19.03.12-dind
#    entrypoint: ["dockerd-entrypoint.sh"]
    command: ["--insecure-registry=registry-domain-name-1", "--insecure-registry=registry-domain-name-2"]
```

