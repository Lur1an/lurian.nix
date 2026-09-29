// Best subsequence alignment, rewarding boundaries and consecutive matches.
// O(query length * candidate length), with deterministic ties in rank().
function score(query, candidate) {
    const needle = query.toLowerCase();
    const text = candidate.toLowerCase();
    if (!needle.length) return 0;
    if (needle.length > text.length) return -Infinity;
    let previous = new Array(text.length).fill(-Infinity);
    for (let i = 0; i < needle.length; ++i) {
        const current = new Array(text.length).fill(-Infinity);
        let best = -Infinity;
        for (let j = 0; j < text.length; ++j) {
            if (j > 0) best = Math.max(best, previous[j - 1] + j - 1);
            if (needle[i] !== text[j]) continue;
            const boundary = j === 0 || /[\s/_.-]/.test(text[j - 1]);
            const bonus = 10 + (boundary ? 12 : 0);
            if (i === 0) current[j] = bonus - j;
            else {
                current[j] = best - j + bonus;
                if (j > 0) current[j] = Math.max(current[j], previous[j - 1] + bonus + 18);
            }
        }
        previous = current;
    }
    return previous.reduce((best, value) => Math.max(best, value), -Infinity) - text.length * 0.01;
}

function rank(entries, query) {
    const tokens = query.trim().split(/\s+/).filter(token => token.length);
    if (!tokens.length) return entries.slice();
    return entries.map((entry, index) => {
        let total = 0;
        for (const token of tokens) {
            const basename = score(token, entry.name);
            const path = score(token, entry.relativePath);
            total += Math.max(basename + 30, path);
        }
        return { entry: entry, score: total, index: index };
    }).filter(match => Number.isFinite(match.score))
      .sort((a, b) => b.score - a.score || a.index - b.index)
      .map(match => match.entry);
}
