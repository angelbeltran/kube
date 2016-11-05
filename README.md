# kube

```sh
npm run build                 # build next version and "latest" images, and run webpack in necessary directories
npm run deploy                # create all services and deployments
npm run deploy-back-end       # create back-end service and deployment
npm run deploy-front-end      # create front service and deployment
npm run deploy-volumes        # create (persistent) volumes and (persistent) volume claims
npm run destroy               # delete all services and deployments
npm run destroy-back-end      # delete back-end service and deployment
npm run destroy-front-end     # delete front-end service and deployment
npm run destroy-db            # delete db service and deployment
npm run destroy-volumes       # delete (persistent) volumes and (persistent) volume claims
npm run update                # update images in all deployments to latest tag (but not literally "latest")
npm run setup                 # setup env vars for minikube, and build images (for initial setup)
npm start                     # start proxy server to front-end service
```
