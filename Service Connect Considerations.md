Service Connect Considerations

- [ ] Update environment variable for name service on line 639 on `./iac/starter-cfn.yaml` to your name; be sure to also update the service connect cfn template for the same environment variable `./iac/serviceconnect-cfn.yaml` on line 706.

- [ ] Add Service Connect Namespace
- [ ] Add Service Connect Configuration to each ECS Service
- [ ] Update the dependency for each service to now depend on the Service Connect Namespace
- [ ] Update Security Group Rules