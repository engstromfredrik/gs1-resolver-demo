import * as cdk from 'aws-cdk-lib';
import * as acm from 'aws-cdk-lib/aws-certificatemanager';
import * as route53 from 'aws-cdk-lib/aws-route53';
import { Construct } from 'constructs';

interface DomainStackProps extends cdk.StackProps {
  domainName: string;
  hostedZoneName: string;
}

export class DomainStack extends cdk.Stack {
  public readonly certificate: acm.Certificate;
  public readonly hostedZone: route53.IHostedZone;

  constructor(scope: Construct, id: string, props: DomainStackProps) {
    super(scope, id, props);

    // Lookup existing hosted zone by ID to avoid ambiguity
    this.hostedZone = route53.HostedZone.fromHostedZoneAttributes(this, 'HostedZone', {
      hostedZoneId: 'Z02189273AOR9DCFLK4K',
      zoneName: props.hostedZoneName,
    });

    // Create ACM certificate (must be in us-east-1 for CloudFront)
    this.certificate = new acm.Certificate(this, 'Certificate', {
      domainName: props.domainName,
      validation: acm.CertificateValidation.fromDns(this.hostedZone),
    });

    new cdk.CfnOutput(this, 'CertificateArn', {
      value: this.certificate.certificateArn,
      exportName: 'GS1ResolverCertificateArn',
    });
  }
}
