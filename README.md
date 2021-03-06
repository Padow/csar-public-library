# csar-public-library
A public TOSCA Cloud Service ARchive (csar) library of Types and Topologies.

## Rules

Here are the rules concerning csars naming nomenclature and version management.

### All components of the same branch or tag of this repository must share the same TOSCA DSL version.

### All components of the same branch or tag of this repository must share the same Normative Types version.

### Include in comments where to find dependency repositories (if different from this one).

### Type naming nomenclature.

The pattern is:

```
DOMAIN_NAME.PRODUCT_DOMAIN.TYPE[.PLATFORM][.ARTIFACT_IMPLEM].NAME
```

with 

```
TYPE=nodes|relationships|capabilities|artifacts|datatypes
```

And with:

- package name in lower case
- NAME in upper camel case

For example:

- org.alien4cloud.java.nodes.JDK
- org.alien4cloud.java.relationships.JavaSoftwareHostedOnJDK
- org.alien4cloud.java.nodes.linux.bash.JDK

When it's need, the major version of a software component can be added to it's name (for example when your type can not manager several versions):

- org.alien4cloud.java.nodes.JDK7

### Type properties are named using snake case.

Example: 

- java_home
- component_version

### The tosca.nodes.Root component_version property must be used to specify software version.

Example: 

- For JDK version 7u51 

```
component_version:
  type: version
  default: 7.0.51
  constraints:
    - valid_values: [ "7.0.51" ]
```
