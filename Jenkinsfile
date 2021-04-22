def label = "ImageBuildPod-${UUID.randomUUID().toString()}"

properties([
  parameters([
    string(name: 'klar_version', defaultValue: '2.4.0'),
    string(name: 'alpine_version', defaultValue: '3.12')
  ])
])

podTemplate(
  label: label,
  containers: [
    containerTemplate(name: 'docker',
                      image: 'docker:19.03',
                      ttyEnabled: true,
                      command: 'cat',
                      envVars: [containerEnvVar(key: 'DOCKER_HOST', value: "unix:///var/run/docker.sock")],
                      privileged: true)
  ],
  volumes: [hostPathVolume(hostPath: '/var/run/docker.sock', mountPath: '/var/run/docker.sock')],
  nodeSelector: 'role=infra'
) {
  node(label) {
    container('docker') {
      def image

      stage('Checkout Code') {
        cleanWs()
        checkout scm
      }

      stage('Build'){
        ansiColor('xterm') {
          // Since the Dockerfile needs network connectivity, connect to the k8s sidecar with --network: https://stackoverflow.com/a/49408621/64217
          image = docker.build("steampunkfoundry/klar:${env.BUILD_ID}", "--network container:\$(docker ps | grep \$(hostname) | grep k8s_POD | cut -d\" \" -f1) --build-arg klar_version=${params.klar_version} --build-arg alpine_version=${params.alpine_version} .")
          image.tag("latest")
          image.tag("v${params.klar_version}")
        }
      }

      stage('Push'){
        docker.withRegistry("https://registry.hub.docker.com", "ggotimer-docker-hub") {
          image.push("latest")
          image.tag("v${params.klar_version}")
        }
      }
    }
  }
}
