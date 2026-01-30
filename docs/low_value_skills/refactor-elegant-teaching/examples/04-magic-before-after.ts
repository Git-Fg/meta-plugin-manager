// BEFORE: Magic numbers without explanation
function calculateShipping(weight: number, distance: number): number {
  if (weight > 0 && weight <= 5 && distance < 100) {
    return 5.99;
  } else if (weight > 5 && weight <= 20 && distance >= 100 && distance < 500) {
    return 12.99;
  } else if (weight > 20 || distance >= 500) {
    return 24.99;
  }
  return 0;
}

// AFTER: Named constants make business logic clear
const WEIGHT_THRESHOLD_LIGHT = 5;
const WEIGHT_THRESHOLD_HEAVY = 20;
const DISTANCE_THRESHOLD_LOCAL = 100;
const DISTANCE_THRESHOLD_REGIONAL = 500;

const PRICE_LIGHT_LOCAL = 5.99;
const PRICE_MEDIUM_REGIONAL = 12.99;
const PRICE_HEAVY_OR_DISTANCE = 24.99;

function calculateShipping(weight: number, distance: number): number {
  if (weight <= 0) return 0;

  const isLight = weight <= WEIGHT_THRESHOLD_LIGHT;
  const isMedium =
    weight > WEIGHT_THRESHOLD_LIGHT && weight <= WEIGHT_THRESHOLD_HEAVY;
  const isHeavyOrFar =
    weight > WEIGHT_THRESHOLD_HEAVY || distance >= DISTANCE_THRESHOLD_REGIONAL;

  const isLocal = distance < DISTANCE_THRESHOLD_LOCAL;
  const isRegional =
    distance >= DISTANCE_THRESHOLD_LOCAL &&
    distance < DISTANCE_THRESHOLD_REGIONAL;

  if (isLight && isLocal) return PRICE_LIGHT_LOCAL;
  if (isMedium && isRegional) return PRICE_MEDIUM_REGIONAL;
  if (isHeavyOrFar) return PRICE_HEAVY_OR_DISTANCE;

  return 0;
}
