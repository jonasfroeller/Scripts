import axios from 'axios';
import fs from 'fs';

// This function fetches all starred repositories of a given github user.
// to run the file:
// npm install -g ts-node
// ts-node filename.ts

const username = 'jonasfroeller';
const REQUESTS_PER_MINUTE = 60;
const RATE_LIMIT_DELAY = 60 * 1000 / REQUESTS_PER_MINUTE;

interface Repo {
    id: number;
    name: string;
    description: string | null;
    owner: {
        id: number;
        login: string;
        avatar_url: string;
        html_url: string;
    };
    html_url: string | null;
    created_at: string;
    updated_at: string;
    git_url: string;
    clone_url: string;
    ssh_url: string;
    svn_url: string;
    homepage: string;
    size: number;
    stargazers_count: number;
    watchers_count: number;
    forks_count: number;
    open_issues_count: number;
    language: string;
    archived: boolean;
    license: {
        spdx_id: string;
        url: string;
    } | null;
    is_template: boolean;
    topics: string[] | null;
}

async function fetchStarredRepos(username: string): Promise<Repo[]> {
    let page = 1;
    const repos: Repo[] = [];

    while (true) {
        await delay(RATE_LIMIT_DELAY);

        const response = await axios.get(`https://api.github.com/users/${username}/starred`, {
            params: {
                page: page,
                per_page: 100,
            },
        });

        const repoData = response.data.map((repo: Repo) => ({
            ...repo,
            owner: {
                ...repo.owner
            },
            license: repo.license ? {
                ...repo.license
            } : null,
        }));

        repos.push(...repoData);

        const nextPageUrl = getNextPageUrl(response.headers.link);
        if (!nextPageUrl) {
            break;
        }

        page = getPageFromUrl(nextPageUrl);
    }

    return repos;
}

function getNextPageUrl(linkHeader: string): string | null {
    const links = linkHeader.split(',');

    for (const link of links) {
        const [url, rel] = link.split(';').map(part => part.trim());
        if (rel === 'rel="next"') {
            const nextPageUrl = url.match(/<(.*?)>/);
            return nextPageUrl ? nextPageUrl[1] : null;
        }
    }

    return null;
}

function getPageFromUrl(url: string): number {
    const regex = /page=(\d+)/;
    const match = url.match(regex);
    if (match) {
        return parseInt(match[1]);
    }
    return 1;
}

function delay(ms: number): Promise<void> {
    return new Promise(resolve => setTimeout(resolve, ms));
}

async function generateHTML(username: string) {
    const repos = await fetchStarredRepos(username);

    let html = `<html>
      <body>
        <h1>Starred Repositories of ${username}</h1>
        <ul>`;

    for (const repo of repos) {
        html += `\n<li>
            <a href="${repo.html_url}">${repo.name}</a>
            <p>${repo.description || ''}</p>
            <p>Owner: <a href="${repo.owner.html_url}">${repo.owner.login}</a></p>
            <p>Language: ${repo.language}</p>
            <p>Stars: ${repo.stargazers_count}</p>
            <p>Created: ${repo.created_at}</p>
            <p>Updated: ${repo.updated_at}</p>
            <p>License: ${repo.license ? repo.license.spdx_id : 'None'}</p>
          </li>
          <hr>`;
    }

    html += `\n</ul>
      </body>
    </html>`;

    return html;
}

generateHTML(username)
    .then(html => {
        fs.writeFileSync('starred_repos.html', html);
        console.log('HTML generated and saved successfully!');
    })
    .catch(error => {
        console.error('Error generating HTML:', error);
    });
