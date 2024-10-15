import { writeFileSync } from "node:fs";

const USE_GITHUB_TOKEN = false;
const GITHUB_TOKEN = "<AUTH-KEY>";

const username = "jonasfroeller";
const REQUESTS_PER_MINUTE = 60;
const RATE_LIMIT_DELAY = (60 * 1000) / REQUESTS_PER_MINUTE;

interface MinimalRepo {
    html_url: string | null;
    name: string,
    description: string | null,
    owner: {
        id: number;
        login: string;
        avatar_url: string;
        html_url: string;
    };
    language: string;
    stargazers_count: number;
    created_at: string;
    updated_at: string;
    license: {
        spdx_id: string;
        url: string;
    } | null;
}

interface Repo extends MinimalRepo {
    id: number;
    git_url: string;
    clone_url: string;
    ssh_url: string;
    svn_url: string;
    homepage: string;
    size: number;
    watchers_count: number;
    forks_count: number;
    open_issues_count: number;
    archived: boolean;
    is_template: boolean;
    topics: string[] | null;
}

/**
 * # Fetches all starred repositories of a given GitHub user.
 * 
 * This function makes paginated requests to the GitHub API to retrieve
 * all repositories starred by a specified user. It utilizes rate limiting
 * to ensure compliance with GitHub API restrictions and can optionally
 * use a GitHub token for authenticated requests.
 * 
 * ## Usage
 * 
 * ```
 * npm install -g ts-node
 * ts-node filename.ts
 * ```
 * or 
 * `bun run script.ts`
 * 
 * ## Parameters
 * 
 * @param {string} username - The GitHub username whose starred repositories
 *                            are to be fetched.
 * @returns {Promise<string[]>} A promise that resolves to an array of URLs
 *                              representing the starred repositories.
 * 
 * @throws {Error} Throws an error if the API response is not successful.
 */
async function fetchStarredRepos(username: string): Promise<MinimalRepo[]> {
    let page = 1;
    const repos: MinimalRepo[] = [];

    while (true) {
        await delay(RATE_LIMIT_DELAY);

        const response = await fetch(
            `https://api.github.com/users/${username}/starred?page=${page}&per_page=100`,
            USE_GITHUB_TOKEN
                ? {
                    headers: {
                        Authorization: `token ${GITHUB_TOKEN}`,
                    },
                }
                : {}
        );

        if (!response.ok) {
            throw new Error(`Failed to fetch page ${page}: ${response.statusText}`);
        }

        const data = await response.json();

        const repoData = data.map((repo: Repo) => ({
            html_url: repo.html_url,
            name: repo.name,
            description: repo.description,
            owner: repo.owner,
            language: repo.language,
            stargazers_count: repo.stargazers_count,
            created_at: repo.created_at,
            updated_at: repo.updated_at,
            license: repo.license,
        }));

        repos.push(...repoData);

        console.log(repos);
        console.log("repos.length", repos.length);

        const linkHeader = response.headers.get('link');
        console.log("Link header:", linkHeader);

        const nextPageUrl = getNextPageUrl(linkHeader);
        if (!nextPageUrl) {
            break;
        }

        page = getPageFromUrl(nextPageUrl);
        console.log("Next page:", page);
    }

    return repos;
}

function getNextPageUrl(linkHeader: string | null): string | null {
    if (!linkHeader) return null;
    const links = linkHeader.split(",");

    for (const link of links) {
        const [url, rel] = link.split(";").map((part) => part.trim());
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
        return Number.parseInt(match[1]);
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
    .then((html) => {
        writeFileSync("starred-repos.html", html);
        console.log("HTML generated and saved successfully!");
    })
    .catch((error) => {
        console.error("Error generating HTML:", error);
    });
