"node-selector": {
	annotations: {}
	attributes: {
		appliesToWorkloads: ["*"]
		podDisruptive: true
	}
	description: ""
	labels: {}
	type: "trait"
}

template: {
	patch: spec: template: spec: {
		if parameter.nodeSelector != _|_ {
			nodeSelector: {
				for k, v in parameter.nodeSelector {
					"\(k)": v
				}
			}
		}
		if parameter.tolerations != _|_ {
			tolerations: [
				for k, v in parameter.tolerations {
					effect:   "NoSchedule"
					key:      k
					operator: "Equal"
					value:    v
				}]
		}
	}
	parameter: {
		nodeSelector: [string]: string
		tolerations?: [string]: string
	}
}
