# Kubernetes
[✏️](https://github.com/meleu/my-notes/edit/master/kubernetes.md)

## reading: Cloud Native DevOps with Kubernetes

### Chapter 1

Kubernetes was based on **Borg**, a container orchestrator used internally by Google.

This paper about Borg seems to be a valuable reading: <https://research.google/pubs/pub43438.pdf>

**What makes Kubernetes so valuable?**

> Kubernetes do the things that the very best system administrator would do: automation, failover, centralized logging, monitoring. It takes what we've learned in the DevOps community and makes it the default, out of the box.

~ Kelsey Hightower


#### Will Kubernetes Disappear?

> Oddly enough, despite the current excitement around Kubernetes, we may not be talking much about it in years to come. Many things that once were new and revolutionary are now so much part of the fabric of computing that we don't really think about them: microprocessors, the mouse, the internet.
> 
> Kubernetes, too, is likely to disappear and become part of the plumbing. It's boring, in a good way: once you learn what you need to know to deploy your application to Kubernetes, you're more or less done.
> 
> The future of Kubernetes is likely to lie largely in the realm of managed services. Virtualization, which was once an exciting new technology, has now simply become a utility. Most people rent virtual machines from a cloud provider rather than run their own virtualization platform, such as vSphere or Hyper-V.
> 
> In the same way, we think Kubernetes will become so much a standard part of the plumbing that you just won't know it's there anymore.

From "Cloud Native DevOps with Kubernetes" book.

#### Kubernetes Doesn't Do It All

> (...) some things just aren't a good fit for Kubernetes (databases, for example).
> While it's perfectly possible to run stateful workloads like databases in Kubernetes with enterprise-grade reliability, it requires a large investment of time and engineering that it may not make sense for your compatny to make. It's usually more cost-effective to use managed services instead.


#### Developer Productivity Engineering

> By the time an engineering organization reaches ~75 people, there is almost certainly a central infrastructure team in place starting to build common substrate features required by product teams building microservices. But there comes a point at which the central infrastrucutre team can no longer both continue to build and operate the infrastructure critical to business success, while also maintaining the support burden of helping product teams with operational tasks.

~ Matt Klein



### Chapter 2

#### the `demo` app

**Running the `demo` container**
```sh
docker container run \
  -p 9999:8888 \
  --name hello \
  cloudnatived/demo:hello
```

And then access <http://localhost:9999/>

**Building the `demo` image**

The provided `Dockerfile` for the [demo](https://github.com/cloudnativedevops/demo) app (written in go) is interesting:
```Dockerfile
FROM golang:1.14-alpine AS build

WORKDIR /src/
COPY main.go go.* /src/
RUN CGO_ENABLED=0 go build -o /bin/demo

FROM scratch
COPY --from=build /bin/demo /bin/demo
ENTRYPOINT ["/bin/demo"]
```

It generates an image `FROM scratch` with only the `demo` binary. It is possible because "Go is a compiled language that can produce self-contained executables, it's ideal for writing minimal (_scratch_) containers."

```sh
git clone https://github.com/cloudnativedevops/demo
cd demo/hello
docker image build -t myhello .

# try to launch the image you've just created
docker container run -p 9999:8888 myhello
# test connection in localhost:9999
```
