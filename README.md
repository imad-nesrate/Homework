Créer une tâche

Fonction : create_task
Description : Demande à l'utilisateur de fournir les détails de la tâche, tels que le titre, la date d'échéance, la description, le lieu et le statut (complété ou non). Valide les entrées pour s'assurer qu'elles sont correctes et ajoute la tâche au fichier tasks.txt.
Mettre à jour une tâche

Fonction : update_task
Description : Demande l'identifiant de la tâche à mettre à jour, puis demande quel champ (titre, description, lieu, date d'échéance, statut) doit être modifié. Met à jour la tâche avec les nouvelles informations fournies par l'utilisateur.
Supprimer une tâche

Fonction : delete_task
Description : Demande l'identifiant de la tâche à supprimer. Retire cette tâche du fichier tasks.txt.
Afficher les détails d'une tâche

Fonction : task_info
Description : Demande l'identifiant de la tâche à afficher. Affiche les détails complets de cette tâche.
Lister les tâches pour une date spécifique

Fonction : list_tasks_by_day
Description : Demande une date spécifique (format YYYY-MM-DD). Affiche toutes les tâches prévues pour cette date, séparant celles qui sont complétées de celles qui ne le sont pas.
Rechercher des tâches par titre

Fonction : search_task_by_title
Description : Demande un titre ou une partie de titre. Affiche toutes les tâches dont le titre correspond à la recherche.
Lister les tâches du jour

Fonction : list_tasks
Description : Si le script est exécuté sans argument, il liste automatiquement les tâches pour la date du jour.

Structure Principale
Détection des Arguments : Le script vérifie les arguments passés lors de son exécution. Si aucun argument n'est fourni, il liste les tâches du jour. Sinon, il exécute la fonction correspondant à l'argument (create, update, delete, info, list, search).
