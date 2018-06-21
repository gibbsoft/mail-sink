# mail-sink

Not sure of the origin of this, but when I find it I will give credit to the
original author. Thanks to Justin Davis of RedHat for help on this. My
modifications are purely to get this running as a non-root dynamic user for
use on OpenShift.

I tested this on an Ubuntu machine running OpenShift in Vagrant, but it could
be deployed on any OpenShift platform.

## Running in Vagrant

### Install the OpenShift `oc` Tool

Download and extract the latest openshift tools from [openshift.org](https://www.openshift.org/download.html#oc-platforms)
into the working directory.

```bash
$ wget https://github.com/openshift/origin/releases/download/v3.9.0/openshift-origin-client-tools-v3.9.0-191fece-linux-64bit.tar.gz
$ tar -xf openshift-origin-client-tools-v3.9.0-191fece-linux-64bit.tar.gz \
  --wildcards --no-anchored --strip-components 1 '*/oc'
```

It's handy to have `oc` in your local Ubuntu as well as within the Vagrant VM
so that you can use the `./deploy.sh` script.

```bash
$ sudo cp oc /usr/local/bin/
```

### Starting Vagrant

Start Vagrant, and within it your OpenShift instance will install and start
too:

```bash
$ vagrant up
```

### Checking the Pod Launched

If all goes well you should now be able to login to the OpenShift console:

username: developer
passord: any  (litterally anything will do)

[https://127.0.0.1:8443/console/project/mail-sink/overview](https://127.0.0.1:8443/console/project/mail-sink/overview)

Look for the status of the `mail-sink` project, it might take a while to build
and deploy.

Once the build has completed succesfully then you should be able to login
to the mail pod:

username: smtp
password: smtp

[https://mail-sink-mail-sink.127.0.0.1.nip.io:4443/cgi-bin/sqwebmail](https://mail-sink-mail-sink.127.0.0.1.nip.io:4443/cgi-bin/sqwebmail)


### Making Changes

For rapid development, it's handy to edit files in the working directory of
your repo, commit and push changes to the remote git repo, then run the
deployment script. For example:

```bash
$ oc login -u developer
Password: any
Logged into "https://127.0.0.1:8443" as "developer" using existing credentials.

You have access to the following projects and can switch between them with 'oc project <projectname>':

    default
    kube-public
    kube-system
  * mail-sink
    myproject
    openshift
    openshift-infra
    openshift-node
    openshift-web-console

Using project "mail-sink".
$ vi template.yml
$ vi README.md
$ vi Dockerfile
$ git add -A
$ git commit -m "example changes"
[master ad3e8c1] example changes
 2 files changed, 26 insertions(+), 2 deletions(-)
$ git push -u origin HEAD
Warning: Permanently added 'github.com,192.30.253.113' (RSA) to the list of known hosts.
Counting objects: 4, done.
Delta compression using up to 12 threads.
Compressing objects: 100% (4/4), done.
Writing objects: 100% (4/4), 574 bytes | 574.00 KiB/s, done.
Total 4 (delta 3), reused 0 (delta 0)
remote: Resolving deltas: 100% (3/3), completed with 3 local objects.
To github.com:gibbsoft/mail-sink.git
   29a7c73..ad3e8c1  HEAD -> master
Branch 'master' set up to track remote branch 'master' from 'origin'.
$ ./deploy.sh
Logged into "https://127.0.0.1:8443" as "developer" using existing credentials.

You have access to the following projects and can switch between them with 'oc project <projectname>':

    default
    kube-public
    kube-system
  * mail-sink
    myproject
    openshift
    openshift-infra
    openshift-node
    openshift-web-console

Using project "mail-sink".
Already on project "mail-sink" on server "https://127.0.0.1:8443".
deploymentconfig "mail-sink" deleted
buildconfig "mail-sink-docker-build" deleted
imagestream "mail-sink" deleted
route "mail-sink" deleted
service "mail-sink-web" deleted
service "mail-sink-web-sec" deleted
--> Deploying template "mail-sink/mail-sink" for "template.yml" to project mail-sink

     * With parameters:
        * APPLICATION_NAME=mail-sink
        * SOURCE_REPOSITORY_URL=https://github.com/gibbsoft/mail-sink.git
        * SOURCE_REPOSITORY_REF=master
        * Dockerfile path=.
        * Dockerfile name=Dockerfile
        * MEMORY_LIMIT=1Gi
        * User Password=PcdO6g4gV662A

--> Creating resources ...
    imagestream "mail-sink" created
    buildconfig "mail-sink-docker-build" created
    deploymentconfig "mail-sink" created
    service "mail-sink-smtp" created
    service "mail-sink-web-sec" created
    service "mail-sink-web-imap" created
    service "mail-sink-web" created
    route "mail-sink" created
--> Success
    Build scheduled, use 'oc logs -f bc/mail-sink-docker-build' to track its progress.
    Access your application via route 'mail-sink-mail-sink.127.0.0.1.nip.io'
    Run 'oc status' to view your app.
$
```

Rinse and repeat as required.

### Cleaning Up

Once you have finished development or testing, then blow it all away:

```bash
$ vagrant destroy -f
```
