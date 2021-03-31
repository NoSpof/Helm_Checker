package main

import data.kubernetes

name = input.metadata.name
podTemplateKinds = ["Deployment","StatefulSet","ReplicationController","DaemonSet","ReplicaSet"]

check_labels(obj, key) {
  obj[key]
}

list_has_value(list, val) {
  element := list[_]
  element == val
}

has_pod_template(kind) {
  list_has_value(podTemplateKinds, kind)
}

required_deployment_labels {
    input.metadata.labels["app"]
    input.metadata.labels["team"]
}

deny[msg] {
    not required_deployment_labels
    msg = sprintf("%s must include labels app and team", [name])
}
# Check that images contain tags
deny[msg] {
  kind = input.kind
  name = input.metadata.name
  has_pod_template(kind)
  image = input.spec.template.spec.containers[_].image
  not contains(image,":")
  msg = sprintf("%s/%s must specify a container image tag (%s)", [kind,name,image])
}
deny[msg] {
  kind = "Pod"
  name = input.metadata.name
  image = input.spec.containers[_].image
  not contains(image,":")
  msg = sprintf("%s/%s must specify a container image tag (%s)", [kind,name,image])
}

# Check that images don't use latest tag
deny[msg] {
  kind = input.kind
  name = input.metadata.name
  has_pod_template(kind)
  image = input.spec.template.spec.containers[_].image
  endswith(image,"latest")
  msg = sprintf("%s/%s shouldn't use latest image tag (%s)", [kind,name,image])
}

deny[msg] {
  kind = "Pod"
  name = input.metadata.name
  image = input.spec.containers[_].image
  endswith(image,"latest")
  msg = sprintf("%s/%s shouldn't use latest image tag (%s)", [kind,name,image])
}