"""
Disease Information Database
Contains comprehensive information about apple leaf diseases
"""

DISEASE_DATABASE = {
    "Apple Scab": {
        "id": "disease_001",
        "name": "Apple Scab",
        "scientific_name": "Venturia inaequalis",
        "description": "Apple scab is a fungal disease that causes olive-green to brown spots on leaves and fruit. It's one of the most common and serious diseases of apple trees worldwide.",
        
        "symptoms": [
            "Olive-green to dark brown spots on leaves",
            "Leaves may curl and pucker",
            "Premature leaf drop",
            "Dark, scabby lesions on fruit",
            "Corky, cracked areas on fruit surface",
            "Twig infections in severe cases"
        ],
        
        "causes": [
            "Fungus Venturia inaequalis",
            "Wet, cool spring weather",
            "Poor air circulation",
            "Overhead irrigation",
            "Infected leaves left on ground"
        ],
        
        "organic_treatment": [
            "Apply neem oil spray every 7-10 days",
            "Use sulfur-based fungicides",
            "Apply copper soap fungicides",
            "Remove and destroy infected leaves",
            "Apply compost tea as foliar spray",
            "Use baking soda solution (1 tbsp per gallon)"
        ],
        
        "chemical_treatment": [
            "Apply myclobutanil fungicides",
            "Use captan or mancozeb",
            "Apply during early spring before infection",
            "Follow label instructions for dosage",
            "Rotate fungicides to prevent resistance"
        ],
        
        "prevention": [
            "Plant resistant apple varieties",
            "Ensure proper tree spacing for air circulation",
            "Prune trees annually for good air flow",
            "Clean up fallen leaves in autumn",
            "Apply dormant oil in late winter",
            "Monitor trees regularly for early signs"
        ],
        
        "seasonal_care": {
            "spring": "Apply preventive fungicides before bud break. Monitor new growth for signs of infection.",
            "summer": "Continue monitoring and treat at first signs. Remove infected leaves and fruit.",
            "fall": "Rake and destroy fallen leaves. Apply compost around trees.",
            "winter": "Prune to improve air circulation. Apply dormant oil spray."
        },
        
        "severity_levels": {
            "mild": "Few spots on leaves, no defoliation",
            "moderate": "Spots on many leaves, some leaf curling",
            "severe": "Extensive leaf spots, defoliation, fruit lesions"
        },
        
        "images": {
            "early_stage": "/images/diseases/apple_scab_early.jpg",
            "late_stage": "/images/diseases/apple_scab_late.jpg",
            "fruit": "/images/diseases/apple_scab_fruit.jpg"
        },
        
        "references": [
            "University of California IPM",
            "Cornell University Plant Disease Diagnostic Clinic",
            "American Phytopathological Society"
        ]
    },
    
    "Black Rot": {
        "id": "disease_002",
        "name": "Black Rot",
        "scientific_name": "Botryosphaeria obtusa",
        "description": "Black rot is a fungal disease that affects apple leaves, fruit, and branches. It causes characteristic 'frogeye' leaf spots and fruit rot.",
        
        "symptoms": [
            "Purple spots on leaves that enlarge to form 'frogeye' lesions",
            "Concentric rings in leaf spots",
            "Brown, sunken areas on fruit",
            "Black, pimple-like structures on fruit",
            "Cankers on branches and twigs",
            "Mummified fruit that remains on tree"
        ],
        
        "causes": [
            "Fungus Botryosphaeria obtusa",
            "Infected wood and mummified fruit",
            "Wounds from pruning or insects",
            "Stress from drought or poor nutrition",
            "Warm, wet weather"
        ],
        
        "organic_treatment": [
            "Apply copper-based fungicides",
            "Remove infected plant parts immediately",
            "Use Bacillus subtilis based products",
            "Apply compost tea for prevention",
            "Use garlic spray as natural fungicide"
        ],
        
        "chemical_treatment": [
            "Apply thiophanate-methyl",
            "Use captan sprays during growing season",
            "Apply during early infection stages",
            "Rotate fungicides to prevent resistance",
            "Follow label instructions carefully"
        ],
        
        "prevention": [
            "Prune out dead or diseased branches",
            "Remove mummified fruit from trees",
            "Avoid overhead irrigation",
            "Maintain tree vigor with proper nutrition",
            "Sterilize pruning tools between cuts",
            "Remove nearby wild hosts"
        ],
        
        "seasonal_care": {
            "spring": "Prune out infected branches before growth. Apply protective fungicides.",
            "summer": "Remove infected fruit and leaves. Monitor for cankers.",
            "fall": "Clean up all fallen fruit and leaves. Remove mummified fruit.",
            "winter": "Inspect and prune out cankers. Apply dormant spray."
        },
        
        "severity_levels": {
            "mild": "Few leaf spots, no fruit infection",
            "moderate": "Multiple leaf spots, some fruit lesions",
            "severe": "Extensive leaf infection, fruit rot, branch cankers"
        },
        
        "images": {
            "leaf": "/images/diseases/black_rot_leaf.jpg",
            "fruit": "/images/diseases/black_rot_fruit.jpg",
            "branch": "/images/diseases/black_rot_branch.jpg"
        },
        
        "references": [
            "Ohio State University Extension",
            "Penn State Extension",
            "The American Phytopathological Society"
        ]
    },
    
    "Cedar Apple Rust": {
        "id": "disease_003",
        "name": "Cedar Apple Rust",
        "scientific_name": "Gymnosporangium juniperi-virginianae",
        "description": "Cedar apple rust is a fungal disease that requires both apple and cedar (juniper) trees to complete its life cycle. It causes distinctive orange spots on leaves.",
        
        "symptoms": [
            "Bright orange-yellow spots on upper leaf surface",
            "Tubular structures on leaf undersides",
            "Small, dark dots in orange spots",
            "Premature leaf drop",
            "Galls on young fruit",
            "Gelatinous orange horns on cedar galls in spring"
        ],
        
        "causes": [
            "Fungus Gymnosporangium juniperi-virginianae",
            "Presence of nearby cedar trees",
            "Warm, wet spring weather",
            "Spores from cedar galls",
            "Poor air circulation"
        ],
        
        "organic_treatment": [
            "Apply sulfur powder during early season",
            "Use copper soap fungicides",
            "Remove nearby cedar trees if possible",
            "Apply baking soda solution (1 tbsp per gallon)",
            "Use neem oil sprays"
        ],
        
        "chemical_treatment": [
            "Apply myclobutanil fungicides",
            "Use propiconazole products",
            "Apply during pink stage of bloom",
            "Treat every 10-14 days in wet weather",
            "Follow label instructions for timing"
        ],
        
        "prevention": [
            "Plant resistant apple varieties",
            "Remove nearby cedar trees (within 1-2 miles)",
            "Apply preventive fungicides in spring",
            "Maintain good air circulation",
            "Monitor for galls on cedar trees",
            "Prune out galls on cedars in winter"
        ],
        
        "seasonal_care": {
            "spring": "Apply fungicides from pink through petal fall. Remove cedar galls before spore release.",
            "summer": "Remove infected leaves and fruit. Monitor for secondary infections.",
            "fall": "Clean up fallen leaves. Plan cedar removal if needed.",
            "winter": "Prune out galls on cedar trees. Apply dormant spray."
        },
        
        "severity_levels": {
            "mild": "Few leaf spots, no defoliation",
            "moderate": "Many leaf spots, some leaf distortion",
            "severe": "Extensive leaf infection, defoliation, fruit damage"
        },
        
        "images": {
            "leaf_upper": "/images/diseases/cedar_rust_leaf_upper.jpg",
            "leaf_lower": "/images/diseases/cedar_rust_leaf_lower.jpg",
            "fruit": "/images/diseases/cedar_rust_fruit.jpg"
        },
        
        "references": [
            "USDA Forest Service",
            "University of Kentucky Extension",
            "Missouri Botanical Garden"
        ]
    },
    
    "Healthy": {
        "id": "disease_004",
        "name": "Healthy",
        "description": "Your apple leaf appears healthy with no signs of disease. Continue good maintenance practices to keep it that way.",
        
        "characteristics": [
            "Normal green color",
            "Intact leaf surface",
            "Uniform growth",
            "No spots or lesions",
            "No discoloration",
            "Normal leaf shape"
        ],
        
        "organic_maintenance": [
            "Continue regular watering schedule",
            "Apply compost or organic mulch",
            "Use seaweed extract for plant health",
            "Maintain proper nutrition",
            "Monitor regularly for early signs"
        ],
        
        "chemical_maintenance": [
            "No treatment needed if healthy",
            "Continue preventive spraying if in season",
            "Follow regular orchard management",
            "Apply dormant oil in winter"
        ],
        
        "maintenance_tips": [
            "Regular monitoring for early detection",
            "Maintain good orchard hygiene",
            "Proper fertilization and watering",
            "Prune regularly for good air flow",
            "Remove any suspicious leaves promptly",
            "Test soil annually for nutrients"
        ],
        
        "seasonal_care": {
            "spring": "Apply balanced organic fertilizer. Monitor for pest emergence.",
            "summer": "Monitor for pests and diseases. Maintain adequate water.",
            "fall": "Clean up fallen leaves. Apply compost around trees.",
            "winter": "Prune for shape and air flow. Plan next year's management."
        },
        
        "images": {
            "healthy_leaf": "/images/diseases/healthy_leaf.jpg",
            "healthy_tree": "/images/diseases/healthy_tree.jpg"
        },
        
        "references": [
            "Sustainable Apple Production Guide",
            "Organic Orchard Management",
            "Good Agricultural Practices"
        ]
    }
}

def get_disease_info(disease_name):
    """Get information for a specific disease"""
    return DISEASE_DATABASE.get(disease_name, DISEASE_DATABASE["Healthy"])

def get_all_diseases():
    """Get all disease information"""
    return DISEASE_DATABASE

def search_diseases(query):
    """Search diseases by name or description"""
    results = {}
    query = query.lower()
    
    for key, value in DISEASE_DATABASE.items():
        if query in key.lower() or query in value.get('description', '').lower():
            results[key] = value
    
    return results

def get_treatment_recommendations(disease_name, treatment_type='both'):
    """Get treatment recommendations by type"""
    disease = get_disease_info(disease_name)
    
    if treatment_type == 'organic':
        return disease.get('organic_treatment', [])
    elif treatment_type == 'chemical':
        return disease.get('chemical_treatment', [])
    else:
        return {
            'organic': disease.get('organic_treatment', []),
            'chemical': disease.get('chemical_treatment', [])
        }