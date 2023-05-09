"x-gateway": {
	annotations: {}
	attributes: {
	}
	name:        "x-gateway"
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
					for _, route in parameter.routes {
						for k, v in route.http {
							name:       "http-\(v)"
							port:       v
							targetPort: v
						}
					},
				]
			}
		}
		ingress: {
			apiVersion: "networking.k8s.io/v1"
			kind:       "Ingress"
			metadata: {
				name: context.name
				annotations: {
					if parameter.certIssuer != _|_ {
						"cert-manager.io/cluster-issuer": parameter.certIssuer
					}
				}
			}
			spec: {
				if parameter.class != _|_ {
					ingressClassName: parameter.class
				}
				rules: [
					for _, route in parameter.routes {
						host: route.domain
						http: {
							paths: [
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
					},
				]
				tls: [
					for _, r in parameter.routes {
						if r.enableTLS {
							hosts: [r.domain]
							secretName: "cert-" + r.domain
						}
					},
				]
			}
		}
	}

	#Route: {
		// +usage=Specify the domain you want to expose
		domain: string

		// +usage=Specify the tls switch
		enableTLS: *false | bool

		// +usage=Specify the mapping relationship between the http path and the workload port
		http: [string]: int
	}

	parameter: {
		// +usage=Specify the class of ingress to use
		class?: string

		// +usage=Specify the class of ingress to use
		certIssuer: string

		// +usage=Routes
		routes: [...#Route]
	}
}
