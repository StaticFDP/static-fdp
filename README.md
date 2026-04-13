# Static FAIR Data Point

A framework for publishing a [FAIR Data Point (FDP)](https://specs.fairdatapoint.org/)
backed entirely by static files on GitHub — no running server required.

Metadata is maintained as RDF Turtle in a Git repository, validated with
[ShEx](https://shex.io/), and published to GitHub Pages. Community contributions
arrive via GitHub Issue forms (or optional web forms) and are automatically
converted into DCAT-compliant datasets by GitHub Actions.

## How it works

```
Contributors
    │
    ├── GitHub Issue forms ──────────────┐
    │                                    ▼
    └── (optional) Web forms ──────────► GitHub Issues
         (Cloudflare Worker)                 │
                                             ▼
                                   GitHub Actions workflows
                                     ┌───────┴────────┐
                                     ▼                 ▼
                              issues_to_datasets.py   publish.yml
                                     │                 │
                                     ▼                 ▼
                              datasets/{slug}/    docs/fdp/ (RDF)
                              docs/datasets/      generated/ (SHACL)
                                     │                 │
                                     └────────┬────────┘
                                              ▼
                                        GitHub Pages
                                    (static FAIR Data Point)
                                              │
                                              ▼
                                     FDP Index (optional)
```

1. **Contribute** — submit structured data via a GitHub Issue form or web form
2. **Validate** — ShEx schemas check every RDF resource on every PR
3. **Convert** — GitHub Actions transform issues into per-topic FAIR datasets
4. **Publish** — Turtle, JSON-LD, and HTML are served from GitHub Pages
5. **Index** — an optional FDP index crawls and aggregates published FDPs

## Quick start

```bash
git clone https://github.com/StaticFDP/static-fdp.git
cd static-fdp
chmod +x setup.sh

./setup.sh \
  --name "my-project" \
  --title "My FAIR Data Point" \
  --org "MyOrg" \
  --publisher "My Working Group" \
  --publisher-url "https://example.org/" \
  --domain "fdp.example.org" \
  --output ./my-new-fdp
```

This generates a ready-to-push repository with ShEx profiles, GitHub Actions
workflows, issue templates, and a DCAT catalog — all parameterized for your
project.

See **[DEPLOY.md](DEPLOY.md)** for the full deployment guide, including
prerequisites and optional components (Cloudflare Worker, ORCID, FDP Index).

## Repository layout

```
static-fdp/
├── README.md                 <- You are here
├── DEPLOY.md                 <- Full deployment & prerequisites guide
├── setup.sh                  <- Bootstrap script for new instances
├── profiles/                 <- ShEx validation schemas (primary)
│   ├── FairDataPoint.shex
│   ├── Catalog.shex
│   └── Dataset.shex
├── templates/                <- Parameterized templates
│   ├── catalog.ttl           <- DCAT catalog with {{placeholders}}
│   ├── wrangler.toml         <- Cloudflare Worker config
│   ├── issue-templates/      <- GitHub Issue form templates
│   │   ├── 01-contribution.yml
│   │   └── config.yml
│   └── workflows/            <- GitHub Actions workflows
│       ├── validate.yml      <- ShEx/SHACL validation on PRs
│       ├── publish.yml       <- Build + deploy FDP to GitHub Pages
│       ├── convert-issues.yml<- Issues -> FAIR datasets
│       └── deploy-worker.yml <- Cloudflare Worker deployment
├── fdp-index/                <- How to deploy or join the FDP Index
│   └── README.md
├── examples/                 <- Worked examples
│   └── leiden-longevity-study/
├── docs/                     <- Specification & diagrams
│   ├── spec/                 <- ReSpec FDP layout specification
│   └── images/               <- FDP metadata diagrams
└── LICENSE                   <- MIT
```

## Validation

ShEx is the **primary** validation gate — PRs cannot merge if ShEx validation
fails. SHACL schemas are generated automatically from ShEx for ecosystem
compatibility but are not blocking.

| Schema | Validates |
|---|---|
| `profiles/FairDataPoint.shex` | FDP root resource |
| `profiles/Catalog.shex` | `dcat:Catalog` entries |
| `profiles/Dataset.shex` | `dcat:Dataset` entries |

## FDP Index

The companion [fdp-index](https://github.com/StaticFDP/fdp-index) repository
provides a serverless FDP index that crawls registered FDPs daily and publishes
a searchable catalog at [staticfdp.github.io/fdp-index](https://staticfdp.github.io/fdp-index/).

See **[fdp-index/README.md](fdp-index/README.md)** for how to register your
FDP or deploy your own index.

## Live deployments

| FDP | Repository |
|---|---|
| [GA4GH Rare Disease Trajectories](https://fdp.semscape.org/ga4gh-rare-disease-trajectories/) | [StaticFDP/ga4gh-rare-disease-trajectories](https://github.com/StaticFDP/ga4gh-rare-disease-trajectories) |

## Specification

The [FDP Layout specification](docs/spec/respec.html) describes the RDF graph
structures required to construct a conformant FAIR Data Point, based on DCAT2.

## Previous version

The original EJP-RD-specific implementation is preserved on the
[`archive/v0-ejprd`](https://github.com/StaticFDP/static-fdp/tree/archive/v0-ejprd)
branch.

## License

[MIT](LICENSE)
