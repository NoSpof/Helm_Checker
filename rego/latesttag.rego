package k8sblocklatesttag

        violation[{"msg": msg}] {
            container := input.review.object.spec.containers[_]
            contains(container.image , ":latest")
            msg := sprintf("Container %v has invalid tags latest.", [container.name])
        }

        violation[{"msg": msg}] {
          container:= input.review.object.spec.containers[_]
          not contains(container.image, ":")
          msg := sprintf("Container %v has invalid tags.",[container.name])
        }
