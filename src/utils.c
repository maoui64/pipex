/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   utils.c                                            :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: magahat <magahat@student.42.fr>            +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/08/20 17:36:53 by magahat           #+#    #+#             */
/*   Updated: 2024/09/02 14:55:34 by magahat          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "../includes/pipex.h"

int	exit_handler(int n)
{
	if (n == 2)
		perror("ERR_OUTFILE");
	if (n == 3)
		perror("ERR_PIPE");
	if (n == 4)
		perror("ERR_FORK");
	if (n == 6)
		perror("ERR_EXECUTE_CMD");
	if (n == 7)
		write(2, "ERR_HEREDOC\n", 13);
	unlink(".tmp");
	exit (1);
}

void	free_double(char **tab)
{
	int	i;

	i = 0;
	while (tab[i])
	{
		free(tab[i]);
		i++;
	}
	free(tab[i]);
	free(tab);
}

char	*ft_free_double(char *s1, char *s2)
{
	if (s1)
	{
		free(s1);
		s1 = NULL;
	}
	if (s2)
	{
		free(s2);
		s2 = NULL;
	}
	return (NULL);
}
