#!/usr/bin/env groovy

void call() {
  def fileContents = resource 'commonFunctions.sh'
  writeFile file: 'commonFunctions.sh', text: fileContents, encoding: "UTF-8"
}
