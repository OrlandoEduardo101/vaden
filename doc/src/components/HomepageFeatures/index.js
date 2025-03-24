import clsx from 'clsx';
import Heading from '@theme/Heading';
import styles from './styles.module.css';

const FeatureList = [
  {
    title: 'High efficiency and low cost',
    Svg: require('@site/static/img/easy-to-use.svg').default,
    description: (
      <>
        Vaden uses an AOT (Ahead-of-Time) compilation model, generating smaller binaries and remove a backend   
        interpreter necessity to run Dart code. This improves infrastructure, 
        reducing resources consumption and increasing efficiency.
      </>
    ),
  },
  {
    title: 'Much easier',
    Svg: require('@site/static/img/much-easier.svg').default,
    description: (
      <>
        It's syntax is similar to Java, C# and JavaScript, making the 
        learning curve smoother for developers who are familiar with these languages.
      </>
    ),
  },
  {
    title: 'Objective and structured',
    Svg: require('@site/static/img/objetive.svg').default,
    description: (
      <>
        Vaden will be a complete ecosystem, offering security, robust documentation, 
        an efficient ORM and support for connections to enterprise databases such as SQL Server and Oracle.
      </>
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
