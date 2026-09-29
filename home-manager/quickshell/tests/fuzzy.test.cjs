const assert = require("node:assert/strict");
const fs = require("node:fs");
const path = require("node:path");
const vm = require("node:vm");
const { test } = require("node:test");

const fuzzy = vm.createContext({});
vm.runInContext(fs.readFileSync(path.join(__dirname, "../qml/wallpaper/Fuzzy.js"), "utf8"), fuzzy);
const entries = [
  { name: "forest.mp4", relativePath: "nature/forest.mp4" },
  { name: "night-city.webm", relativePath: "urban/night-city.webm" },
  { name: "waterfall.gif", relativePath: "nature/waterfall.gif" },
  { name: "wallpaper.jpg", relativePath: "forest/wallpaper.jpg" },
];
const names = (query) => Array.from(fuzzy.rank(entries, query), (entry) => entry.name);

test("subsequence search is case insensitive, ordered, and rejects misses", () => {
  assert.equal(names("WTF")[0], "waterfall.gif");
  assert.deepEqual(names("xyz"), []);
  assert.equal(fuzzy.score("ba", "abc"), -Infinity);
  assert.ok(Number.isFinite(fuzzy.score("aa", "abca")));
});

test("basename and consecutive matches rank above scattered or path matches", () => {
  assert.equal(names("forest")[0], "forest.mp4");
  assert.ok(fuzzy.score("city", "city.webm") > fuzzy.score("city", "c_i_t_y.webm"));
});

test("multiple tokens match relative paths in any order", () => {
  assert.deepEqual(names("gif nature"), ["waterfall.gif"]);
});

test("empty queries and equal scores preserve library order without mutation", () => {
  assert.deepEqual(names("  "), entries.map((entry) => entry.name));
  const duplicates = [{ name: "a.jpg", relativePath: "a.jpg", id: 1 }, { name: "a.jpg", relativePath: "a.jpg", id: 2 }];
  assert.deepEqual(Array.from(fuzzy.rank(duplicates, "a"), (entry) => entry.id), [1, 2]);
  assert.equal(entries[0].name, "forest.mp4");
});
