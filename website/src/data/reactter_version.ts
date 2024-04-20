const data = (await fetch("https://pub.dev/api/packages/reactter")
  .then((res) => (res.status === 200 ? res : Promise.reject(res)))
  .then((res) => res.json())
  .then((data) => data.latest.version)
  .catch(() => null)) as string | null;

export default data;
