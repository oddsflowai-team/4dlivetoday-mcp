// Print the newest 1st/2nd/3rd prize of every operator. Node 18+ (built-in fetch).
const res = await fetch("https://4dlivetoday.com/api/v1/latest");
if (!res.ok) throw new Error(`HTTP ${res.status}`);
const body = await res.json();

for (const d of body.data) {
  console.log(`${d.date}  ${d.operator_name.padEnd(22)} 1st ${d.first}  2nd ${d.second}  3rd ${d.third}`);
}
console.log(`\n${body.attribution}`);
