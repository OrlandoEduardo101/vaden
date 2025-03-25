import Translate, { translate } from '@docusaurus/Translate';
import Heading from '@theme/Heading';
import clsx from 'clsx';
import styles from './styles.module.css';

const FeatureList = [
 {
   title: translate({
     message: 'High efficiency and low cost',
     description: 'First feature title'
   }),
   Svg: require('@site/static/img/easy-to-use.svg').default,
   description: (
     <Translate 
       id="homepage.features.efficiency.description"
       description="Description of efficiency feature"
     >
       Vaden uses an AOT (Ahead-of-Time) compilation model, generating smaller binaries and remove a backend
       interpreter necessity to run Dart code. This improves infrastructure,
       reducing resources consumption and increasing efficiency.
     </Translate>
   ),
 },
 {
   title: translate({
     message: 'Much easier',
     description: 'Second feature title'
   }),
   Svg: require('@site/static/img/much-easier.svg').default,
   description: (
     <Translate
       id="homepage.features.learning.description"
       description="Description of learning curve feature"
     >
       It's syntax is similar to Java, C# and JavaScript, making the
       learning curve smoother for developers who are familiar with these languages.
     </Translate>
   ),
 },
 {
   title: translate({
     message: 'Objective and structured',
     description: 'Third feature title'
   }),
   Svg: require('@site/static/img/objetive.svg').default,
   description: (
     <Translate
       id="homepage.features.ecosystem.description"
       description="Description of ecosystem feature"
     >
       Vaden will be a complete ecosystem, offering security, robust documentation,
       an efficient ORM and support for connections to enterprise databases such as SQL Server and Oracle.
     </Translate>
   ),
 },
];

function Feature({Svg, title, description}) {
  return (
    <div className={clsx('col col--4')}>
      <div className="text--center">
        <Svg className={styles.featureSvg} role="img" />
      </div>
      <div className="text--center padding-horiz--md">
        <Heading as="h3">{title}</Heading>
        <p>{description}</p>
      </div>
    </div>
  );
}

export default function HomepageFeatures() {
  return (
    <section className={styles.features}>
      <div className="container">
        <div className="row">
          {FeatureList.map((props, idx) => (
            <Feature key={idx} {...props} />
          ))}
        </div>
      </div>
    </section>
  );
}