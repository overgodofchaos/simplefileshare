# simplefileshare
The simplest application for distributing files via http\https using basic http authentication.


# usage
## launching

1. clone repo and make own compose file
```shell
git clone <this_repo>
cd <this_repo>
cp docker-compose.example.yaml docker-compose.yaml
```
2. modify the compose file to suit your needs.
3. create file storage
4. run with `docker compose up --build -d`
   
example compose file content:
```yaml
services:
  simplefileshare:
    build: .
    container_name: simplefileshare
    ports:
      - "9080:80"
    environment:
      GIT_ENABLED: true # Optional. If using git.
      GIT_REPO: "git:exampleuser/repo.git" # Optional. If using git.
      GIT_SYNC_INTERVAL: "*/15 * * * *" # Optional. If using git. Cron-like.
    volumes:
      # - "./user_data/files:/data/files" # Optional. If NOT using git.
      - "./user_data/ssh:/root/ssh" # Optional. If using private git repo.
```

## using a git repository as file storage
Mount the directory with git configs into the container at /root/ssh. And configure it according to suit your needs.

To access a private repository, you'll need a key file.

You can configure access to the service on a non-standard port using the config file.

Config file example:
```plaintext
Host git
	HostName github.com
	User git
	Port 22
	IdentityFile "~/.ssh/key"
	IdentitiesOnly yes
	StrictHostKeyChecking accept-new
```
*The key file containing the private key should be located next to the config file. The corresponding public key should be added to the Git account.*


## file storage structure
```plaintext
.
├── .htpasswd
├── <dirname1>
│   ├── file1.txt
│   ├── file2.png
│   ├── ...
│   └── fileN.json
└── <dirname2>
    ├── file1.txt
    ├── file2.png
    ├── ...
    └── fileN.json
```
Can be stored as a regular directory or as a separate git repository

## user control
each user gets access to a directory with the same name

### using htpasswd

#### add user / change password
```shell
htpasswd /path/to/.htpasswd <name>
```
or
```shell
htpasswd -b /path/to/.htpasswd <name> <password>
```
#### delete user
```
htpasswd -D /path/to/.htpasswd <name>
```

### manually
1. get password hash with `openssl passwd -apr1`
2. add `<name>:<password_hash>` to .htpasswd
   - example `user1:$apr1$izUBA9oj$oG3rfLeXmwdsjAT5iAjkz1`


