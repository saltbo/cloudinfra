"x-gateway": {
	annotations: {}
	attributes: {
	}
	name: "x-gateway"
	description: "gateway with ssl."
	labels: {}
	type: "trait"
}

template: {
	outputs: {
		ingress:{
				apiVersion: "networking.k8s.io/v1"
				kind:       "Ingress"
				metadata: {
					name: context.name
					annotations: {
						if parameter.certIssuer != _|_ {
							"cert-manager.io/issuer": parameter.certIssuer
						}
					}
				}
				spec: {
					ingressClassName: parameter.class
					rules: [
						for _, route in parameter.routes {
							host: route.domain
							http: paths: [
								for k, v in route.http {
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
					tls: [
						// for _, r in parameter.routes {
						// 	if r.enableTLS {
						// 		hosts: [r.domain]
						// 		secretName: "cert-"+r.domain
						// 	}
						// }
					]
				}
			}
	}
	parameter:
			// +usage=Specify the class of ingress to use
			class: *"nginx" | string

			// +usage=Specify the class of ingress to use
			certIssuer: string

			// +usage=Routes
			routes: [
						{
							// +usage=Specify the domain you want to expose
							domain: string

							// +usage=Specify the tls switch
							enableTLS?: *false | bool

							// +usage=Specify the mapping relationship between the http path and the workload port
							http: [string]: int
						}
		]
}

