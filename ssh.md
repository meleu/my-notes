# SSH
[✏️](https://github.com/meleu/my-notes/edit/master/ssh.md)

## Criar um usuário sem senha com acesso apenas por chave pública SSH

Resumo rápido e rasteiro do que aprendi aqui: [https://unix.stackexchange.com/questions/210228/add-a-user-without-password-but-with-ssh-and-public-key](https://unix.stackexchange.com/questions/210228/add-a-user-without-password-but-with-ssh-and-public-key):

### Na máquina "local"

Primeiro é necessário criar uma chave pública na máquina que será usada para acessar o servidor remoto:

```
ssh-keygen -t dsa
```

Isso vai gerar o arquivo `/home/USERNAME/.ssh/id_dsa.pub`.

### Na máquina remota

1. Criar o usuário sem senha:
```
useradd --create-home --home-dir /home/USERNAME --shell /bin/bash USERNAME
```

2. Copiar o conteúdo de `/home/{USER_NAME}/.ssh/id_dsa.pub` **da máquina local** e colar **na máquina remota** em `/home/USERNAME/.ssh/authorized_keys`.

3. Configurar as permissões
```
chown -R USERNAME:USERNAME /home/USERNAME/.ssh
chmod 700 /home/USERNAME/.ssh
chmod 600 /home/USERNAME/.ssh/authorized_keys
```

Pode ser uma boa dar uma olhadinha em `/etc/ssh/sshd_config` e certificar-se que `PubkeyAuthentication yes`.

Se tudo der certo agora é possível ir na "máquina local" e se logar sem senha usando o comando:
```
ssh USERNAME@maquinaremota
```
