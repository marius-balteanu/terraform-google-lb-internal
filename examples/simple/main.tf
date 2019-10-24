/*
 * Copyright 2019 Google Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

provider "google" {
  region = var.region
}

module "gce-lb-fr" {
  source       = "GoogleCloudPlatform/lb/google"
  version      = "~> 2.0"
  region       = var.region
  network      = var.network
  project      = var.project
  name         = "group1-lb"
  service_port = local.named_ports[0].port
  target_tags  = local.target_tags
}

module "gce-ilb" {
  source       = "../../"
  region       = var.region
  name         = "group-ilb"
  ports        = [local.named_ports[0].port]
  source_tags  = local.source_tags
  target_tags  = local.target_tags
  health_check = var.health_check

  backends = [
    {
      group = module.mig2.instance_group
    },
    {
      group = module.mig3.instance_group
    },
  ]
}
