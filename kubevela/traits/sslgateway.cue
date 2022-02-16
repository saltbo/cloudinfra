sslgateway: {
	annotations: {}
	attributes: {
	}
	name: "sslgateway"
	description: "gateway with ssl."
	labels: {}
	type: "trait"
}

template: {
	outputs: {
		service: {
			apiVersion: "v1"
			kind:       "Service"
			metadata: name: context.name
			spec: {
				selector: "app.oam.dev/component": context.name
				ports: [
					for k, v in parameter.http {
						port:       v
						targetPort: v
					},
				]
			}
		},
	}
	outputs: {
		ingress:{
				apiVersion: "networking.k8s.io/v1"
				kind:       "Ingress"
				metadata: {
					name: context.name
					annotations: {
						if !parameter.classInSpec {
							"kubernetes.io/ingress.class": parameter.class
						}
						if parameter.certIssuer != _|_ {
							"cert-manager.io/issuer": parameter.certIssuer
						}
					}
				}
				spec: {
					rules: [{
							host: parameter.domain
							http: paths: [
								for k, v in parameter.http {
									path:     k
									pathType: "ImplementationSpecific"
									backend: service: {
										name: context.name
										port:
											number: v
									}
								},
							]
						}
					]
					tls: [{
						hosts: [parameter.domain]
						secretName: "cert-"+parameter.domain
					}]
				}
			}
	}
	parameter: {
			// +usage=Specify the domain you want to expose
			domain: string

			// +usage=Specify the mapping relationship between the http path and the workload port
			http: [string]: int

			// +usage=Specify the class of ingress to use
			class: *"nginx" | string

			// +usage=Set ingress class in '.spec.ingressClassName' instead of 'kubernetes.io/ingress.class' annotation.
			classInSpec: *false | bool

			// +usage=Specify the class of ingress to use
			certIssuer: string
	}
}

