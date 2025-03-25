import Link from '@docusaurus/Link';
import Translate, { translate } from '@docusaurus/Translate';
import useDocusaurusContext from '@docusaurus/useDocusaurusContext';
import HomepageFeatures from '@site/src/components/HomepageFeatures';
import Layout from '@theme/Layout';
import clsx from 'clsx';
import styles from './index.module.css';

function HomepageHeader() {
  const {siteConfig} = useDocusaurusContext();
  return (
    <header className={clsx('hero hero--primary', styles.heroBanner)}>
      <div className="container">
        <img
          src="/img/vaden_logo_text.svg"
          alt={translate({
            message: "Logo with text",
            description: "Alt text for Vaden logo"
          })}
          style={{ width: '300px', height: 'auto' }}
        />
        <p className="hero__subtitle">
          <Translate 
            id="homepage.tagline"
            description="Main tagline on the homepage"
          >
            {siteConfig.tagline}
          </Translate>
        </p>
        <div className={styles.buttons}>
          <Link
            className="button button--secondary button--lg"
            to="/docs/Introduction/getting-started"
          >
            <Translate
              id="homepage.getStarted"
              description="Getting started button text"
            >
              Getting Started - 5min ⏱️
            </Translate>
          </Link>
        </div>
      </div>
    </header>
  );
}

export default function Home() {
  return (
    <Layout
      title={translate({
        message: "Home",
        description: "Page title"
      })}
      description={translate({
        message: "Like Spring Boot, but for Dart.",
        description: "Page description"
      })}
    >
      <HomepageHeader />
      <main>
        <HomepageFeatures />
      </main>
    </Layout>
  );
}