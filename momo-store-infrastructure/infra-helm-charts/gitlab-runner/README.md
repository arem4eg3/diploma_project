helm upgrade --install gitlab-runner . -n gitlab-runner --create-namespace --set runnerRegistrationToken="",gitlabUrl=https://gitlab.praktikum-services.ru


#kubectl apply -f fix-sa-forbidden.yaml
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: gitlab-runner
  namespace: gitlab-runner

---
apiVersion: rbac.authorization.k8s.io/v1
kind: "ClusterRole"
metadata:
  name: gitlab-runner
rules:
- apiGroups: ["*"]
  resources: ["*"]
  verbs: ["*"]

---
apiVersion: rbac.authorization.k8s.io/v1
kind: "ClusterRoleBinding"
metadata:
  name: gitlab-runner
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: "ClusterRole"
  name: gitlab-runner
subjects:
- kind: ServiceAccount
  name: default
  namespace: gitlab-runner
