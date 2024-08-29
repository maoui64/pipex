/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   pipex.c                                            :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: magahat <magahat@student.42.fr>            +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/07/26 14:58:36 by magahat           #+#    #+#             */
/*   Updated: 2024/08/26 18:07:20 by magahat          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "../includes/pipex.h"

int	main(int argc, char **argv, char **envp)
{
	t_pipex	pipex;

	if (argc != 5)
		return (write(2, "ERR_INPUT\n", 11), 0);
	pipex.nb_cmd = 2;
	pipex.here_doc = 0;
	open_fd(argv[1], argv[4], pipex.file, 0);
	pipex.pipes = open_pipes(pipex.nb_cmd - 1);
	manage_cmd(argv, envp, pipex);
	waitpid(-1, NULL, 0);
	close_fd(pipex);
	return (0);
}
